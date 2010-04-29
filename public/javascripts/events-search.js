$(function(){
  function applySelectChain(root_el, child_el, url){
    root_el.selectChain({
      target: child_el,
      url: url,
      data: 'ajax=true&empty_text=1'
    });
  }

  var root_el = $('#events_root_place'), child_el = $('#event_place_id'), url = '/events/cities';
  applySelectChain(root_el, child_el, url);
  var root_el = $('#events_root_subject'), child_el = $('#event_subject_id'), url = '/events/subjects';
  applySelectChain(root_el, child_el, url);
});
