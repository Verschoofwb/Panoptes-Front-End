React = require 'react'
Dialog = require '../components/dialog'

module.exports = (message) ->
  defer =
    resolve: null
    reject: null

  promise = new Promise (resolve, reject) ->
    defer.resolve = resolve
    defer.reject = reject

  if typeof message is 'function'
    message = message defer.resolve, defer.reject

  container = document.createElement 'div'
  container.classList.add 'dialog-container'
  document.body.appendChild container

  previousActiveElement = document.activeElement

  closeButton = <button onClick={defer.resolve}>&times;</button>
  React.render <Dialog className="alert" controls={closeButton} esc={defer.resolve}>
    {message}
  </Dialog>, container

  unmount = ->
    React.unmountComponentAtNode container
    container.parentNode.removeChild container
    previousActiveElement?.focus()

  promise.then unmount, unmount
  promise
