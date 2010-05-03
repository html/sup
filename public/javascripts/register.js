$(function(){
  $('#typus_user_birth_date').datepicker();
  applySelectChain($('#typus_users_root_place'), $('#typus_user_city_id'), '/events/cities');
});
