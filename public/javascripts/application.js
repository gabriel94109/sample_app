// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function micropost_limit(){
  var max = '140';
  var content = $F('micropost_content');
  if(content.length > max){
    content = content.substr(0,max);
  }
  $('limit').innerHTML = max - content.length;
}


