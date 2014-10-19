setCookie = (cname, cvalue, exdays) ->
  d = new Date()
  d.setTime d.getTime() + (exdays * 24 * 60 * 60 * 1000)
  expires = "expires=" + d.toUTCString()
  document.cookie = cname + "=" + cvalue + "; " + expires
  return

getCookie = (cname) ->
  name = cname + "="
  ca = document.cookie.split(";")
  i = 0

  while i < ca.length
    c = ca[i]
    c = c.substring(1)  while c.charAt(0) is " "
    return c.substring(name.length, c.length)  unless c.indexOf(name) is -1
    i++
  ""

$ ->
  if $('body.adventures-edit').length > 0 && getCookie("shepherd") is ""

    setCookie("shepherd", "viewed", 7)

    shepherd = new Shepherd.Tour(
      defaults: {
        classes: 'shepherd-element shepherd-open shepherd-theme-arrows'
        showCancelLink: true
      }
    )

    shepherd.addStep 'welcome', {
      title: 'Welcome to Gilgamesz adventure editor!'
      text: [
        'We have prepared for you a quick tutorial.'
        'You can skip it by just click "Exit".'
      ]
      attachTo: '.navbar.header bottom'
      classes: 'shepherd shepherd-open shepherd-theme-arrows shepherd-transparent-text'
      buttons: [
        {
          text: 'Exit'
          classes: 'shepherd-button-secondary'
          action: shepherd.cancel
        }, {
          text: 'Next'
          action: shepherd.next
          classes: 'shepherd-button-example-primary'
        }
      ]
    }

    shepherd.addStep 'graph', {
      title: 'Plot tree'
      text: [
        'Here are the most important view of the editor.'
        'It shows your created nodes.'
        'When you click in the black box,'
        'you can switch to edit the selected node.'
      ]
      attachTo: '#graph right'
      buttons: [
        {
          text: 'Back'
          classes: 'shepherd-button-secondary'
          action: shepherd.back
        }, {
          text: 'Next'
          action: shepherd.next
        }
      ]
    }

    shepherd.addStep 'nodes', {
      title: 'The "node" tab'
      text: [
        'Here you can change the node name,'
        'describe the story associated with this step in the game'
        'and add next nodes (childs).'
        'Switch now to the "inventory" tab and go ahead.'
      ]
      attachTo: '.tab-content left'
      buttons: [
        {
          text: 'Back'
          classes: 'shepherd-button-secondary'
          action: shepherd.back
        }, {
          text: 'Next'
          action: shepherd.next
        }
      ]
    }

    shepherd.addStep 'inventory', {
      title: 'The "inventory"'
      text: [
        'Here you can add items, which player will be able to use.'
        'Switch to "settings" and go ahead.'
      ]
      attachTo: '.tab-content left'
      buttons: [
        {
          text: 'Back'
          classes: 'shepherd-button-secondary'
          action: shepherd.back
        }, {
          text: 'Next'
          action: shepherd.next
        }
      ]
    }

    shepherd.addStep 'settings', {
      title: 'The "settings" tab'
      text: [
        'Here you can edit the details of your game.'
        'The name and description, are those parts'
        'that encourage the player to play your game.'
        'You can choose one of the specific types of games,'
        'so that your gameplay will be fought in a specific world!'
      ]
      attachTo: '.tab-content left'
      buttons: [
        {
          text: 'Back'
          classes: 'shepherd-button-secondary'
          action: shepherd.back
        }, {
          text: 'Next'
          action: shepherd.next
        }
      ]
    }

    shepherd.addStep 'finish', {
      text: [
        'We hope that you will have a lot of fun with Gilgamesz!'
        'Have fun!'
      ]
      attachTo: '.navbar.header bottom'
      buttons: [
        {
          text: 'Back'
          classes: 'shepherd-button-secondary'
          action: shepherd.back
        }, {
          text: 'Finish'
          action: shepherd.cancel
        }
      ]
    }

    shepherd.start();
