import 'main_prod.dart' as prod;

// By default, if no target (-t) is specified during build or run, 
// Flutter uses lib/main.dart. We forward this entirely to production 
// so the ProII Fantasy League app launches instead of the Demo App.
void main() async {
  prod.main();
}
