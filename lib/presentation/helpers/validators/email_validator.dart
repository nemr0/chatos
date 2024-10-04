String? emailValidator(String? value){
  if(value == null || value.isEmpty){
    return 'Email shouldn\'t be empty.';
  }
  if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
    return 'Please enter a correct email.';
  }
  return null;
}