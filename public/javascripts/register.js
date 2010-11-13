$(function(){
  $('#typus_user_birth_date').datepicker({
    showOn: "button",
    buttonImage: "images/calendar.gif",
    buttonImageOnly: true
  });
  applySelectChain($('#events_root_place'), $('#typus_user_city_id'), '/events/cities');
});
