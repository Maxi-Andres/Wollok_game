import wollok.game.*

object juego {
  method iniciar() {
    game.width(26)
    game.height(20)
    game.ground("Grass Texture 4.png")
    game.addVisualCharacter(mario) // Esto hace que con W,A,S,D lo puedas mover, los addVisual solo hace que spawnee quieto
    game.onCollideDo(mario, { algo => algo.teAgarroMario() })
    self.generarInvasores()
    self.generarCoins()
    //game.schedule(20000, { game.removeTickEvent("aparece invasor") }) en 20 segs deja de aparecer invasores
    keyboard.enter().onPressDo({ game.removeTickEvent("aparece invasor") })
  }
  
  method generarInvasores() {
    game.onTick(1000, "aparece invasor", { new Invasor().aparecer() })
  }
  
  method generarCoins() {
    game.schedule(500, { self.generarCoin(100) })
  }
  
  method generarCoin(valor) {
    const posRandom = self.posicionAleatoria()
    const coin = new Coin(position = posRandom, valor = valor)
    game.addVisual(coin)
    coin.animarse()
  }
  
  method posicionAleatoria() = game.at(
    0.randomUpTo(game.width()),
    0.randomUpTo(game.height())
  )
    //game.say(mario,"MORI!!")
  
  method terminar() {
    game.addVisual(muerte) // Agrega el texto de "Game Over"
    //game.clear() // Luego limpia todos los elementos visuales de la pantalla
    //game.stop() // Detiene el juego para evitar más interacciones
  }
}

object muerte {
  method position() = game.center()
  method image() = "fin.jpg" // Usa la imagen que creaste
}

// method position() = position Esto es lo mismo que un var property
// method position(nueva) {
// position = nueva }
object mario {
  var property position = game.center()
  var puntos = 0 // Definiendo los puntos iniciales
  var vidas = 5
  
  method aumentarPuntos(valor) {
    puntos += valor
  }
  
  method perderVida() {
    vidas -= 1
    if(vidas == 0){
      juego.terminar()
    }
  }

  method vidas() = vidas
  method puntaje() = puntos
  method image() = "mario2.png"
}

class Invasor {
  var position = null
  
  method teAgarroMario() {
    mario.perderVida()
    game.say(mario, ("Me quedan " + mario.vidas()) + " vidas")
    self.desaparecer()
  }
  
  method aparecer() {
    position = juego.posicionAleatoria()
    game.addVisual(self)
    self.moverseAleatoriamente()
    game.schedule(8000, { self.desaparecer() }) //saco enemigos cada 8 segundos porque no hay manera de matarlos todavia...
  }
  
  method moverseAleatoriamente() {}
  
  method position() = position
  method image() = "fantasma.png"
  
  method desaparecer() {
    if (game.hasVisual(self)) 
      game.removeVisual(self)
  }
}

class Coin {
  const image = "coin2.png"
  const valor
  const position
  
  method teAgarroMario() {
    mario.aumentarPuntos(valor)
    game.say(mario, mario.puntaje().toString())
    game.removeVisual(self)
    juego.generarCoin(valor) // cada moneda vale el doble que la anterior
    //juego.generarCoin(valor*2)
  }
  
  method text() = valor.toString()
  method image() = image
  method animarse() {}
  method position() = position
}
