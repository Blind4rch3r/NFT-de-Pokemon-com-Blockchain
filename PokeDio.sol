// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PokeDIO is ERC721{

    struct Pokemon{
        string name;
        uint level;
        string img;
    }

    Pokemon[] public pokemons;
    address private gameOwner;  // A variável gameOwner foi tornada privada para proteger seu acesso.

    constructor () ERC721 ("PokeDIO", "PKD"){
        gameOwner = msg.sender;
    } 

    modifier onlyOwnerOf(uint _monsterId) {
        require(ownerOf(_monsterId) == msg.sender,"Apenas o dono pode batalhar com este Pokemon");
        _;
    }
    
    // A função battle permite que qualquer pessoa chame e altere os níveis dos Pokémons sem restrições adicionais além de
    // Foi necessário verificar com 'require' se ambos os Pokémons estão sob a posse do mesmo proprietário antes da batalha. 
    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon){
        require(ownerOf(_defendingPokemon) == msg.sender, "Você só pode batalhar com um Pokémon que você possui");

        Pokemon storage attacker = pokemons[_attackingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];

         if (attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        }else{
            attacker.level += 1;
            defender.level += 2;
        }
        // Emitir evento ou realizar outras operações necessárias após a batalha
    }
    
    // Agora a função emite um evento após a criação do Pokémon para que os interessados possam rastrear novas criações.
    event PokemonCreated(uint indexed id, string name, address owner, string img);

    function createNewPokemon(string memory _name, address _to, string memory _img) public {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Pokemons");
        uint id = pokemons.length;
        pokemons.push(Pokemon(_name, 1,_img));
        _safeMint(_to, id);
        emit PokemonCreated(id, _name, _to, _img);
    }

    // Como a variável gameOwner agora é privada, foi criada a função pública para acessá-la, se necessário.
    function getGameOwner() public view returns (address) {
        return gameOwner;
    }
}