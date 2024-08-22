import wollok.game.*

object juego {
  method iniciar() {
    game.width(26)
    game.height(20)
    game.addVisualCharacter(mario)
    game.onCollideDo(mario, { algo => algo.teAgarroMario() })
    self.generarInvasores()
    self.generarCoins()
    //game.schedule(20000, { game.removeTickEvent("aparece invasor") })
  }
  
  method generarInvasores() {
    game.onTick(1000, "aparece invasor", { new Invasor().aparecer() })
  }
  
  method generarCoins() {
    game.schedule(500, { self.generarCoin(100) })
  }
  
  method generarCoin(valor) {
    const pos = self.posicionAleatoria()
    const coin = new Coin(position = pos, valor = valor)
    game.addVisual(coin)
    coin.animarse()
  }
  
  method posicionAleatoria() = game.at(
    0.randomUpTo(game.width()),
    0.randomUpTo(game.height())
  )
}

object mario {
  var property position = game.center()
  var puntos = 0 // Definiendo los puntos iniciales
  
  method aumentarPuntos(valor) {
    puntos += valor
  }
  
  // method position() = position Esto es lo mismo que un var property
  // method position(nueva) {
  // position = nueva
  // }
  method image() = "mario2.png"
}

class Invasor {
  // Declarar como propiedad para que se pueda acceder correctamente
  var position = null
  
  method teAgarroMario() {
    
    //perder - sacar vida
  }
  
  method aparecer() {
    position = juego.posicionAleatoria()
    game.addVisual(self)
    self.moverseAleatoriamente()
  }
  
  method moverseAleatoriamente() {
    position = juego.posicionAleatoria()
  }
  
  method position() = position
  
  method image() = "invasor2.png"
}

class Coin {
  var image = "coin2.png"
  var valor
  const position
  
  method teAgarroMario() {
    mario.aumentarPuntos(valor) // Mario gana puntos al agarrar la moneda
  }
  
  method image() = image
  
  method animarse() {
    
  }
  
  method position() = position
}