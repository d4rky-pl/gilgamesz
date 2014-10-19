Editor.Sidebar.Node.Templates = {
  passage: {
    type: 'passage'
    description: 'You are here.'
    actions: []
  },
  add_item: {
    type: 'add_item'
    item_id: null
    events: {
      add_item: {
        description: 'You have found an item.'
        actions: []
      },
      already_have_item: {
        description: 'You already have an item.'
        actions: []
      }
    }
  },
  use_item: {
    type: 'use_item'
    item_id: null
    events: {
      use_item: {
        description: 'You are using item.'
        actions: []
      },
      already_used_item: {
        description: 'You already used your item.'
        actions: []
      },
      no_item: {
        description: "You don't have an item"
        actions: []
      }
    }
  },
  gameover: {
    type: 'gameover'
    description: 'Game over. You lost.'
  },
  finish: {
    type: 'finish'
    description: 'You won.'
  }
}
