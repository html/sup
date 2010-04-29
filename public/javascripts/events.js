function enabledIfChecked(items, checkbox){
  $(items).attr('disabled', !$(checkbox).is(':checked'));
}

$(function(){
  $(['#set_start_time', '#set_end_time']).each(function(){
    var str = this.toString();
    $(str).click(function(){
      enabledIfChecked(str + '_selects select', this);
    });
  });

  $('#set_event_end').click(function(){
    var selects = $('#set_event_end_selects input');
    var set_end_time = $('#set_end_time');

    if(set_end_time.is(':checked') && !$(selects).is(':disabled')){
      set_end_time.click();
    }

    enabledIfChecked($('#set_end_time_selects select'), set_end_time);
    enabledIfChecked(selects.add(set_end_time), this);
  });

  $('#event_start_time, #event_end_time').datepicker();

  function applySelectChain(root_el, child_el, url){
    root_el.selectChain({
      target: child_el,
      url: url,
      data: 'ajax=true'
    });
  }

  var root_el = $('#events_root_place'), child_el = $('#event_place_id'), url = '/events/cities';
  applySelectChain(root_el, child_el, url);
  var root_el = $('#events_root_subject'), child_el = $('#event_subject_id'), url = '/events/subjects';
  applySelectChain(root_el, child_el, url);
});
