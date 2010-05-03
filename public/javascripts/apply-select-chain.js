  function applySelectChain(root_el, child_el, url, empty_text){
    root_el.selectChain({
      target: child_el,
      url: url,
      data: 'ajax=true' + (empty_text ? '&empty_text=1' : '')
    });
  }

