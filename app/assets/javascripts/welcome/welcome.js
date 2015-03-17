console.log('welcome.js loaded');

$(function(){
  $('#view-stats').click(function(){
    console.log('you clicked view my stats');
    makeSignupForm();
  })
})

var makeSignupForm = function() {
  var signupForm = $("<form id='signup' action='/users' method='POST'></form>")

  signupForm.append("<label for='user_name'>Name</label>")
  signupForm.append("<input type='text' name='name'id='user_name'>")

  signupForm.append("<label for='user_email'>Email</label>")
  signupForm.append("<input type='email' name='email'id='user_email'>")
  
  signupForm.append("<label for='user_password'>Password</label>")
  signupForm.append("<input type='password' name='password'id='user_password'>")

  signupForm.append("<label for='user_password_confirmation'>Password confirmation</label>")
  signupForm.append("<input type='password' name='password_confirmation' id='user_password_confirmation'>")

  signupForm.append("<input type='submit' value='Sign up'></input>")
  signupForm.append("<p id='get-login-form'>I already have an account</p>")
  
  $('.modal-form').empty();
  $('.modal-form').append( signupForm ).fadeIn('slow');
  
  // form submit click handler
  $('#signup').on('submit', function(event){
    event.preventDefault();
    console.log('you clicked signup');
    var formData = this.elements;
    var userData = {
      name: formData.name.value,
      email: formData.email.value,
      password: formData.password.value,
      password_confirmation: formData.password_confirmation.value
    }
    signUpUser(userData);
  })

  // form switch click handler
  $('#get-login-form').click(function(){
    makeLoginForm();
  })
}

var makeLoginForm = function() {
  var loginForm = $("<form id='login' action='/sessions' method='POST'></form>")
  loginForm.append("<label for='user_email'>Email</label>")
  loginForm.append("<input type='email' name='email'id='user_email'>")
  
  loginForm.append("<label for='user_password'>Password</label>")
  loginForm.append("<input type='password' name='password'id='user_password'>")

  loginForm.append("<input type='submit' value='Log in'></input>")

  loginForm.append("<p id='get-signup-form'>Create an account</p>")

  $('.modal-form').empty();
  $('.modal-form').append( loginForm );
  
  // call submit click handler
  $('#login').on('submit', function(event){
    event.preventDefault();
    console.log('you clicked login');
    var formData = this.elements;
    var loginData = {
      email: formData.email.value,
      password: formData.password.value
    }
    logInUser(loginData);
  })

  // call #get-signup-form click handler
  $('#get-signup-form').click(function(){
    makeSignupForm();
  })
}


var signUpUser = function(userData) {
  $.ajax({
    url: '/users',
    method: 'POST',
    data: {
      user: userData
    },
    dataType: 'json',
    success: function(data){
      console.log(data);
      if (data.created) {
        window.location.replace("/users/fitbitlogin");
      } else {
        console.log('something went wrong');
        //append a notice to the form saying why the user couldn't be created ...data.errors in the json hash will contain specific info
      }
    }
  })
}

var logInUser = function(loginData) {
  $.ajax({
    url: '/sessions',
    method: 'POST',
    data: {
      user: loginData
    },
    dataType: 'json',
    success: function(data){
      console.log(data);
      if (data.login) {
        window.location.replace("/users/fitbitlogin");
      } else {
        console.log('wrong password');
        // append a notice to the form saying the email & password don't match
      }
    }
  })
}

