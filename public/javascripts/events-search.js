$(function(){
  var root_el = $('#events_root_place'), child_el = $('#event_place_id'), url = '/events/cities';
  applySelectChain(root_el, child_el, url, true);
  var root_el = $('#events_root_subject'), child_el = $('#event_subject_id'), url = '/events/subjects';
  applySelectChain(root_el, child_el, url, true);

  $('#event_start_time, #event_end_time').datepicker();
});
