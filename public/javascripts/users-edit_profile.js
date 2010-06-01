$(function(){
  var root_el = $('#events_root_place'), child_el = $('#typus_user_place_id'), url = '/events/cities';
  applySelectChain(root_el, child_el, url);
  $('#typus_user_birth_date').datepicker();
});
