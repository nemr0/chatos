String? passwordValidator(String? value){
  if(value == null || value.isEmpty){
    return 'Password shouldn\'t be empty.';
  }
  if(value.length<6){
    return 'Password should be at least 6 characters.';
  }
  return null;
}