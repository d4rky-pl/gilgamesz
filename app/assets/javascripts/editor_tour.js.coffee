$ ->
  if $('body.adventures-edit').length > 0

    shepherd = new Shepherd.Tour(
      defaults: {
        classes: 'shepherd-element shepherd-open shepherd-theme-arrows'
        showCancelLink: true
      }
    )

    shepherd.addStep 'welcome', {
      title: 'Witamy w edytorze gry!'
      text: ['Przygotowaliśmy dla Ciebie szybki samouczek, ale możesz też pominąć i spróbować od razu tworzyć gry!']
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
      title: 'Drzewko fabuły'
      text: [
        'Oto najważniejszy widok edytora. Tutaj zobaczysz wszystkie utworzone węzły.'
        'Po kliknięciu w czarne pole, będziesz mógł przełączyć się do edycji wybranego węzła.'
      ]
      attachTo: '.navbar.header bottom'
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
      title: 'Zakładka "węzły"'
      text: [
        'Możesz tutaj zmienić nazwę węzła, rozpisać fabułę związaną z tym krokiem w grze oraz dalsze drogi, którymi można podążać...'
        'Przełącz teraz na zakłądkę "inventory" i przejdź dalej.'
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
      title: 'Zakładka "inwentarz"'
      text: [
        'Możesz tutaj dodawać przedmioty, którymi posługiwał będzie się gracz na określonym węźle.'
        'Przełącz teraz na zakładkę "settings" i przejdź dalej.'
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
      title: 'Zakładka "settings"'
      text: [
        'Tutaj możesz edytować dane swojej gry. Nazwa i opis, to te części, które zachęcą gracza do grania.'
        'Możesz wybrać jeden z określonych typów gry, dzięki czemu Twoja rozgrywka będzie toczona w konkretnym świecie!'
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
        'Mamy nadzieję, że będziesz miał mnóstwo radości z tworzenia!',
        'Jeśli popełniliśmy jakiś błąd, powiadom nas o tym z zakładce "Kontakt".'
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
