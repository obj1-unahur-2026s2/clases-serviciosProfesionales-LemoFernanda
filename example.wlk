// Etapa 1
class Universidad {

var provincia
var honorariosRecomendados

// Etapa 3
var totalDonaciones = 0


method provincia() = provincia
method provincia(nuevaProvincia) {
provincia = nuevaProvincia
}

method honorariosRecomendados() = honorariosRecomendados
method honorariosRecomendados(nuevosHonorarios) {
honorariosRecomendados = nuevosHonorarios
}
// Ajdunto etapa 3
method totalDonaciones() = totalDonaciones
method recibirDonacion(monto){
totalDonaciones += monto
}
}

class ProfesionalVinculado {
var universidad

method universidad() = universidad
method universidad(nuevaUniversidad) {
universidad = nuevaUniversidad
}

method honorariosPorHora() = universidad.honorariosRecomendados()
method provinciasDondePuedeTrabajar() = [universidad.provincia()]

// Ajunto etapa 3
method cobrar(monto){
universidad.recibirDonacion(monto / 2)
}}



class ProfesionalAsociado {
var universidad 

method universidad() = universidad
method universidad(nuevaUniversidad) {
universidad = nuevaUniversidad
}

method honorariosPorHora() = 3000
method provinciasDondePuedeTrabajar() = ["Entre Rios","Santa Fe", "Corrientes"]

// Adjunto etapa 3
method cobrar(monto) {
    asociacionDelLitoral.recibirDonacion(monto)
  }
}

class ProfesionalLibre {
  var universidad
  var honorariosPorHora
  var provinciasDondePuedeTrabajar = []
  var totalRecaudado = 0

  method universidad() = universidad
  method universidad(nuevaUniversidad) { universidad = nuevaUniversidad }

  method honorariosPorHora() = honorariosPorHora
  method honorariosPorHora(nuevosHonorarios) { honorariosPorHora = nuevosHonorarios }

  method provinciasDondePuedeTrabajar() = provinciasDondePuedeTrabajar
  method provinciasDondePuedeTrabajar(nuevasProvincias) { provinciasDondePuedeTrabajar = nuevasProvincias }

   // Adjunto etapa 3
   method totalRecaudado() = totalRecaudado 

   method cobrar(monto) {
   totalRecaudado += monto
   }
   
   method pasarDinero(otroProfesional, cantidad) {
   totalRecaudado -= cantidad
   otroProfesional.cobrar(cantidad)
   }
}


class Empresa {
var honorarioDeReferencia 
const profesionalesContratados = []
// Adjunto etapa 4  
const clientes = #{} // Conjunto para registrar los clientes sin repetidos

method honorarioDeReferencia() = honorarioDeReferencia
method honorariosDeReferencia(nuevoHorario){
honorarioDeReferencia = nuevoHorario
}
method contratar(profesional) {
profesionalesContratados.add(profesional)
}

// cuántos (un número) de sus profesionales contratados estudió en una determinada universidad.
method cuantosEstudiaronEn(universidad) {
return profesionalesContratados.count ({prof => prof.universidad() == universidad })
}

// el conjunto formado por sus profesionales caros.
//O sea, aquellos cuyo honorario es mayor al honorario de referencia de la empresa.

method profesionalesCaros() {
return profesionalesContratados.filter({ prof => prof.honorariosPorHora() > honorarioDeReferencia }).asSet()
}

// el conjunto de las universidades formadoras, o sea, las universidades donde estudiaron sus profesionales contratados, sin repetidos.
method universidadesFormadoras(){
return profesionalesContratados.map({prof => prof.universidad() }).asSet()
}
//el profesional más barato (o sea, que sus honorarios son los más bajos).
method profesionalMasBarato() {
return profesionalesContratados.min({prof => prof.honorariosPorHora()})
}
//si es de gente acotada (o sea, ningún profesional está habilitado para más de tres provincias, o lo que es equivalente, todos trabajan en a lo sumo tres provincias).
method esDeGenteAcotada() {
return profesionalesContratados.all({prof => prof.provinciasDondePuedeTrabajar().size() <= 3})
}

// Metodo para etapa 2
method puedeSatisfacer(solicitante) {
    return profesionalesContratados.any({ prof => solicitante.puedeSerAtendidaPor(prof) })
  
}
// Metodo para etapa 4 - dar servicio
method darServicio(solicitante){
  if (self.puedeSatisfacer(solicitante)) {
    const profesionalElegido = profesionalesContratados.find({ prof => solicitante.puedeSerAtendidaPor(prof) })
    profesionalElegido.cobrar(profesionalElegido.honorariosPorHora())
    clientes.add(solicitante)
  }
}

method cuantosClientes() = clientes.size()
method tieneComoCliente(solicitante) = clientes.contains(solicitante)

// Desafio final - profesional poco atractivo
// Metodo principal en Empresa 
  method esPocoAtractivo(unProfesional) {
    return unProfesional.provinciasDondePuedeTrabajar().all({ prov =>  self.hayOtroMasBaratoEn(unProfesional, prov) })
  }

  // Metodo auxiliar
  method hayOtroMasBaratoEn(unProfesional, provincia) {
    return profesionalesContratados.any({ prof => not (prof == unProfesional) 
      && prof.provinciasDondePuedeTrabajar().contains(provincia)
      && prof.honorariosPorHora() < unProfesional.honorariosPorHora()
    })
  }

  }



// Etapa 2 -Solicitantes
class Persona {
var provinciaDondeVive

method provinciaDondeVive() = provinciaDondeVive
method provinciaDondeVive(nuevaProvincia) {
provinciaDondeVive = nuevaProvincia
}

method puedeSerAtendidaPor(profesional){
return profesional.provinciasDondePuedeTrabajar().contains(provinciaDondeVive)
}
}

class Institucion {
var universidadesReconocidas = []

method universidadesReconocidas() = universidadesReconocidas
method universidadesReconocidas(nuevasUniversidades) {
universidadesReconocidas = nuevasUniversidades
}
method puedeSerAtendidaPor(profesional) {
return universidadesReconocidas.contains(profesional.universidad())
}
}

class Club {
var provinciasDondeEsta = []

method provinciasDondeEsta() = provinciasDondeEsta
method provinciaDondeEsta(nuevasProvincias) {
provinciasDondeEsta = nuevasProvincias
}
method puedeSerAtendidaPor(profesional){
return provinciasDondeEsta.any ({ prov => profesional.provinciasDondePuedeTrabajar().contains(prov) })
}
}

// Etapa 3
// Asociacion del litoral
object asociacionDelLitoral {
var totalRecaudado = 0

method totalRecaudado() = totalRecaudado
method recibirDonacion(monto) {
totalRecaudado += monto 
}
}

