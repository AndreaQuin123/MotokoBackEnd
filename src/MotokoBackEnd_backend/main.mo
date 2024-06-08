import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

actor Votacion {

    // Definir el tipo de cada opcion (como un struct)
    type Opcion = {
        id: Nat;
        descripcion: Text;
        votos: Nat;
    };

    type ErrorOpcion = {
        #opcionNoEncontrada;
    };

    type ResultadoVoto = Result.Result<Text, ErrorOpcion>;

    // Declarando variables
    stable var opciones: [Opcion] = [];
    stable var siguienteOpcionId: Nat = 0;

    // Agregar opcion para votar
    public func agregarOpcion(descripcion: Text): async Opcion {
        let nuevaOpcion: Opcion = {
            id = siguienteOpcionId;
            descripcion = descripcion;
            votos = 0;
        };
        opciones := Array.append<Opcion>(opciones, [nuevaOpcion]);
        siguienteOpcionId := siguienteOpcionId + 1;
        return nuevaOpcion;
    };

    // Imprimir todas las opciones
    public query func obtenerOpciones(): async [Opcion] {
        return opciones;
    };

    // Eliminar todas las opciones (para empezar de nuevo)
    public func eliminarTodasOpciones(): async () {
        opciones := [];
        siguienteOpcionId := 0;
    };

    // Votar por una opcion
    public func votar(opcionId: Nat): async ResultadoVoto {
        var encontrado = false;
        opciones := Array.map<Opcion, Opcion>(opciones, func(opcion) {
            if (opcion.id == opcionId) {
                encontrado := true;
                return { id = opcion.id; descripcion = opcion.descripcion; votos = opcion.votos + 1 };
            } else {
                return opcion;
            }
        });

        if (encontrado) {
            return #ok("Voto agregado");
        } else {
            return #err(#opcionNoEncontrada);
        }
    };

    // Eliminar UN voto
    public func eliminarVoto(opcionId: Nat): async ResultadoVoto {
        var encontrado = false;
        var opcionesActualizadas = Array.map<Opcion, Opcion>(opciones, func(opcion) {
            if (opcion.id == opcionId and opcion.votos > 0) {
                encontrado := true;
                return { id = opcion.id; descripcion = opcion.descripcion; votos = opcion.votos - 1 };
            } else {
                return opcion;
            }
        });

        if (encontrado) {
            opciones := opcionesActualizadas;
            return #ok("Voto eliminado");
        } else {
            return #err(#opcionNoEncontrada);
        }
    };

    // RESETEAR todos los votos
    public func reiniciarVotos(): async () {
        opciones := Array.map<Opcion, Opcion>(opciones, func(opcion) {
            return { id = opcion.id; descripcion = opcion.descripcion; votos = 0 };
        });
    };

    // Contar todos los votos y dictar el ganador
    public query func obtenerGanador(): async ?Opcion {
        if (Array.size(opciones) == 0) {
            return null;
        };
        var ganador = opciones[0];
        for (opcion in opciones.vals()) {
            if (opcion.votos > ganador.votos) {
                ganador := opcion;
            };
        };
        return ?ganador;
    };
}
