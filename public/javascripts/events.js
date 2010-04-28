var l =console.log;
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

  var root_el = $('#events_root_place'), child_el = $('#event_place_id'), opts = document.options;

  root_el.selectChain({
    target: child_el,
    url: '/events/cities',
    data: 'ajax=true'
  });

  if(opts.root_place_id){
    root_el.val(opts.root_place_id);
    root_el.change();
    if (opts.place_id){
      child_el.val(opts.place_id).change();
    }
  };
});
