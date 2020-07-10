import 'package:comet_events/core/services/services.dart';
import 'package:comet_events/utils/locator.dart';
import 'package:comet_events/utils/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum _UserViewModelBuilderType { NonReactive, Reactive }

/// A widget that provides base functionality for the Mvvm style provider architecture by FilledStacks.
class UserViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final Widget staticChild;
  final Function(T, FirebaseUser) onModelReady;
  final Widget Function(BuildContext, T, FirebaseUser, Widget) builder;
  final T Function() userViewModelBuilder;
  final bool disposeViewModel;
  final bool createNewModelOnInsert;
  final _UserViewModelBuilderType providerType;
  final bool fireOnModelReadyOnce;
  final bool autoRedirectToAuth;

  /// Constructs a viewmodel provider that will not rebuild the provided widget when notifyListeners is called.
  ///
  /// Widget from [builder] will be used as a staic child and won't rebuild when notifyListeners is called
  const UserViewModelBuilder.nonReactive({
    @required this.builder,
    @required this.userViewModelBuilder,
    this.onModelReady,
    this.disposeViewModel = true,
    this.createNewModelOnInsert = false,
    this.fireOnModelReadyOnce = false,
    this.autoRedirectToAuth = true,
    Key key,
  })  : providerType = _UserViewModelBuilderType.NonReactive,
        staticChild = null,
        super(key: key);

  /// Constructs a viewmodel provider that fires the [builder] function when notifyListeners is called in the viewmodel.
  const UserViewModelBuilder.reactive({
    @required this.builder,
    @required this.userViewModelBuilder,
    this.staticChild,
    this.onModelReady,
    this.disposeViewModel = true,
    this.createNewModelOnInsert = false,
    this.fireOnModelReadyOnce = false,
    this.autoRedirectToAuth = true,
    Key key,
  })  : providerType = _UserViewModelBuilderType.Reactive,
        super(key: key);

  @override
  _UserViewModelBuilderState<T> createState() => _UserViewModelBuilderState<T>();
}

class _UserViewModelBuilderState<T extends ChangeNotifier>
    extends State<UserViewModelBuilder<T>> {
  T _model;

  @override
  void initState() {
    super.initState();
    if (_model == null) {
      _createViewModel();
    }
    else if (widget.createNewModelOnInsert) {
      _createViewModel();
    }
  }

  void _createViewModel() async {
    if (widget.userViewModelBuilder != null) {
      _model = widget.userViewModelBuilder();
    }

    _initialiseSpecialViewModels();

    if (widget.onModelReady != null) {
      if (widget.fireOnModelReadyOnce &&
          !(_model as BaseViewModel).initialised) {
        await widget.onModelReady(_model, locator<AuthService>().u);
        (_model as BaseViewModel)?.setInitialised(true);
      } else if (!widget.fireOnModelReadyOnce) {
        await widget.onModelReady(_model, locator<AuthService>().u);
      }
    }
  }

  void _initialiseSpecialViewModels() {
    if (_model is Initialisable) {
      (_model as Initialisable).initialise();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.providerType == _UserViewModelBuilderType.NonReactive) {
      if (!widget.disposeViewModel) {
        return ChangeNotifierProvider.value(
          value: _model,
          child: widget.builder(context, _model, locator<AuthService>().u, widget.staticChild),
        );
      }

      return ChangeNotifierProvider(
        create: (context) => _model,
        child: widget.builder(context, _model, locator<AuthService>().u, widget.staticChild),
      );
    }

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
    if (user == null && widget.autoRedirectToAuth) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        locator<NavigationService>().replaceWith(Routes.auth);
      });
    }
    return widget.builder(context, model, user, child);
  }
}

/// EXPERIMENTAL: Returns the ViewModel provided above this widget in the tree
T getParentViewModel<T>(BuildContext context) => Provider.of<T>(context);


// enum _UserViewModelBuilderType { NonReactive, Reactive }

// /// A widget that provides base functionality for the Mvvm style provider architecture by FilledStacks.
// class UserViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
//   final Widget staticChild;
//   final Function(T, FirebaseUser) onModelReady;
//   final Widget Function(BuildContext, T, FirebaseUser, Widget) builder;
//   final T Function() userViewModelBuilder;
//   final bool disposeViewModel;
//   final bool createNewModelOnInsert;
//   final bool autoRedirectToAuth;
//   final _UserViewModelBuilderType providerType;

//   const UserViewModelBuilder.reactive({
//     @required this.builder,
//     @required this.userViewModelBuilder,
//     this.staticChild,
//     this.onModelReady,
//     this.disposeViewModel = true,
//     this.createNewModelOnInsert = false,
//     this.autoRedirectToAuth = true,
//   }) : providerType = _UserViewModelBuilderType.Reactive;

//   @override
//   _UserViewModelBuilderState<T> createState() => _UserViewModelBuilderState<T>();
// }

// class _UserViewModelBuilderState<T extends ChangeNotifier>
//     extends State<UserViewModelBuilder<T>> {
//   T _model;

//   @override
//   void initState() {
//     super.initState();
//     // We want to ensure that we only build the model if it hasn't been built yet.
//     if (_model == null) {
//       _createViewModel();
//     }
//     // Or if the user wants to create a new model whenever initState is fired
//     else if (widget.createNewModelOnInsert) {
//       _createViewModel();
//     }
//   }

//   void _createViewModel() {
//     if (widget.userViewModelBuilder != null) {
//       _model = widget.userViewModelBuilder();
//     }

//     _initialiseSpecialViewModels();

//     // Fire onModelReady after the model has been constructed
//     if (widget.onModelReady != null) {
//       widget.onModelReady(_model, locator<AuthService>().u);
//     }
//   }

//   void _initialiseSpecialViewModels() {
//     if (_model is FutureViewModel) {
//       (_model as FutureViewModel).runFuture();
//     }

//     if (_model is MultipleFutureViewModel) {
//       (_model as MultipleFutureViewModel).runFutures();
//     }

//     if (_model is StreamViewModel) {
//       (_model as StreamViewModel).initialise();
//     }

//     if (_model is MultipleStreamViewModel) {
//       (_model as MultipleStreamViewModel).initialise();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!widget.disposeViewModel) {
//       return ChangeNotifierProvider.value(
//         value: _model,
//         child: Consumer2<T, FirebaseUser>(
//           builder: builderWithDynamicSourceInitialise,
//           child: widget.staticChild,
//         ),
//       );
//     }

//     return ChangeNotifierProvider(
//       create: (context) => _model,
//       child: Consumer2<T, FirebaseUser>(
//         builder: builderWithDynamicSourceInitialise,
//         child: widget.staticChild,
//       ),
//     );
//   }

//   Widget builderWithDynamicSourceInitialise(
//       BuildContext context, T model, FirebaseUser user, Widget child) {
//     if (model is DynamicSourceViewModel) {
//       if (model.changeSource ?? false) {
//         _initialiseSpecialViewModels();
//       }
//     }
//     if (user == null && widget.autoRedirectToAuth) {
//       SchedulerBinding.instance.addPostFrameCallback((_) {
//         locator<NavigationService>().replaceWith(Routes.auth);
//       });
//     }
//     return widget.builder(context, model, user, child);
//   }
// }