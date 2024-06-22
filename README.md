# MotokoBackEnd

### Miembros: 
- Andrea Michell Quin
- Andrea Nicole Altamirano

### Descripcion
Un project simple BackEnd donde se utilizan diferentes funciones para simular una votacion. Se pueden agregar opciones, votar por las opciones, dictar el ganador, eliminar votos y resetear opciones y votos.


## Correr en GitHub CodeSpace

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://redesigned-pancake-wr796vqg6r96359w9.github.dev)

## Correr Localmente

Clone the project

```bash
  git clone https://github.com/AndreaQuin123/MotokoBackEnd.git
```

# Pasos

Ir al directorio del proyecto:

```bash
cd MotokoBackEnd
```

Empezar una replica ICP en el background:

```bash
dfx start --background --clean
```

Deploy los canisters:

```bash
dfx deploy
```

El resultado saldra asi:

```bash
URLs:
  Backend canister via Candid interface:
    backend: http://127.0.0.1:4943/?canisterId=bd3sg-teaaa-aaaaa-qaaba-cai&id=bkyz2-fmaaa-aaaaa-qaaaq-cai
```

Ir al apartado de ports y copiar y pegar el primer port y remplazar en donde se indica:

```bash
URL: [ REPLACE HERE ] ?canisterId=bd3sg-teaaa-aaaaa-qaaba-cai&id=bkyz2-fmaaa-aaaaa-qaaaq-cai
```

Lo llevara al canister donde podra pobrar todas las funciones de nuestro projecto.
