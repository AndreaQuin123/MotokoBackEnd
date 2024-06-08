import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

actor Votacion {

    // Define a type for the options
    type Opcion = {
        id: Nat;
        descripcion: Text;
        votos: Nat;
    };

    type ErrorOpcion = {
        #opcionNoEncontrada;
    };

    type ResultadoVoto = Result.Result<Text, ErrorOpcion>;

    // State variables
    stable var opciones: [Opcion] = [];
    stable var siguienteOpcionId: Nat = 0;

    // Add a voting option
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

    // Get all voting options
    public query func obtenerOpciones(): async [Opcion] {
        return opciones;
    };

    // Delete all options
    public func eliminarTodasOpciones(): async () {
        opciones := [];
        siguienteOpcionId := 0;
    };

    // Vote for an option
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

    // Delete a vote
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

    // Reset all votes
    public func reiniciarVotos(): async () {
        opciones := Array.map<Opcion, Opcion>(opciones, func(opcion) {
            return { id = opcion.id; descripcion = opcion.descripcion; votos = 0 };
        });
    };

    // Count all votes and give the option with the best amount of votes
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
