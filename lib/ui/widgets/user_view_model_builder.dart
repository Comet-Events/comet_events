import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

enum _ViewModelBuilderType { NonReactive, Reactive }

/// A widget that provides base functionality for the Mvvm style provider architecture by FilledStacks.
class ViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final Widget staticChild;
  final Function(T) onModelReady;
  final Widget Function(BuildContext, T, FirebaseUser, Widget) builder;
  final T Function() viewModelBuilder;
  final bool disposeViewModel;
  final bool createNewModelOnInsert;
  final _ViewModelBuilderType providerType;

  const ViewModelBuilder.reactive({
    @required this.builder,
    @required this.viewModelBuilder,
    this.staticChild,
    this.onModelReady,
    this.disposeViewModel = true,
    this.createNewModelOnInsert = false,
  }) : providerType = _ViewModelBuilderType.Reactive;

  @override
  _ViewModelBuilderState<T> createState() => _ViewModelBuilderState<T>();
}

class _ViewModelBuilderState<T extends ChangeNotifier>
    extends State<ViewModelBuilder<T>> {
  T _model;

  @override
  void initState() {
    super.initState();
    // We want to ensure that we only build the model if it hasn't been built yet.
    if (_model == null) {
      _createViewModel();
    }
    // Or if the user wants to create a new model whenever initState is fired
    else if (widget.createNewModelOnInsert) {
      _createViewModel();
    }
  }

  void _createViewModel() {
    if (widget.viewModelBuilder != null) {
      _model = widget.viewModelBuilder();
    }

    _initialiseSpecialViewModels();

    // Fire onModelReady after the model has been constructed
    if (widget.onModelReady != null) {
      widget.onModelReady(_model);
    }
  }

  void _initialiseSpecialViewModels() {
    if (_model is FutureViewModel) {
      (_model as FutureViewModel).runFuture();
    }

    if (_model is MultipleFutureViewModel) {
      (_model as MultipleFutureViewModel).runFutures();
    }

    if (_model is StreamViewModel) {
      (_model as StreamViewModel).initialise();
    }

    if (_model is MultipleStreamViewModel) {
      (_model as MultipleStreamViewModel).initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.disposeViewModel) {
      return ChangeNotifierProvider.value(
        value: _model,
        child: Consumer2<T, FirebaseUser>(
          builder: builderWithDynamicSourceInitialise,
          child: widget.staticChild,
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => _model,
      child: Consumer2<T, FirebaseUser>(
        builder: builderWithDynamicSourceInitialise,
        child: widget.staticChild,
      ),
    );
  }

  Widget builderWithDynamicSourceInitialise(
      BuildContext context, T model, FirebaseUser user, Widget child) {
    if (model is DynamicSourceViewModel) {
      if (model.changeSource ?? false) {
        _initialiseSpecialViewModels();
      }
    }
    return widget.builder(context, model, user, child);
  }
}