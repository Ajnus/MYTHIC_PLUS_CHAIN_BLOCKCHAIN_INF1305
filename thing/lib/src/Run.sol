// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.16 <0.8.0;
pragma experimental ABIEncoderV2;

contract Run
{
    address payable dono;

    struct Player // contratante ou contratado
    {
        uint id;
        address payable addr;
        string nickname;
		string guild;
        string server;
        uint custo;
        string masmorra;
    }

    Player[] players; // implementar estrutura mais capaz
    
    uint valorCasa;
    uint valorPlayer;
    uint troco;
    

    constructor() public
    {
        dono = msg.sender;
    }

    function set(string memory _nickname, string memory _guild, string  memory _server, uint _custo,
				 string memory _masmorra) public
	{
		players.push(Player(
		{
			id: players.length+1,
			addr: msg.sender,
			nickname: _nickname,
			guild: _guild,
            server: _server,
            custo: _custo,
            masmorra: _masmorra
		}
		));
	}
	
	function get(uint id) public view returns (string memory, string memory, string memory, address, 
											   uint, string memory)
    {
        return (players[id-1].nickname, 
				players[id-1].guild, 
				players[id-1].server, 
				players[id-1].addr, 
				players[id-1].custo, 
				players[id-1].masmorra);
    }
    
    function getDono() public view returns (address)
    {
        return dono;
    }

    modifier apenasDono()
	{
		require(msg.sender == dono, "Apenas o dono do contrato pode fazer isso");
		_;
	}

	modifier excetoDono()
	{
		require(msg.sender != dono, "O dono do contrato nao pode fazer isso");
		_;
	}

    event TrocoEnviado(address pagador, uint troco);

    function sendMoney (uint _contratadoID) payable public /*excetoDono()*/ returns (uint, uint, uint)
	{
		require(msg.value >= players[_contratadoID-1].custo, "O valor de deposito é insuficiente.");
		
		// se houver, calcula e envia troco
		troco = msg.value - players[_contratadoID-1].custo;
		if(troco > 0)
		{
		msg.sender.send(troco);
		emit TrocoEnviado(msg.sender, troco);
	    }

		valorCasa = players[_contratadoID-1].custo/100;      		     		// % da casa
 		valorPlayer = players[_contratadoID-1].custo - valorCasa;	    		// valor transferido
		dono.send(valorCasa);
		players[_contratadoID-1].addr.send(valorPlayer);

	

	// registra a corrida
	//corridas[msg.sender] = corrida;
	//corridas.push(msg.sender);
	//emit CorridaRegistrada(msg.sender, );
	}
	
	function postSendMoney() public view returns (uint, uint, uint)
	{
	   	return (valorCasa, valorPlayer, troco);
	}
	
}