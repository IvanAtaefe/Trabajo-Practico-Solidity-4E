// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Estudiante{
    string private _nombre;
    string private _apellido;
    string private _curso;
    address private _docente;
    string[] private _materias;
    mapping(string => uint8) private _notas_materias;

    constructor (string memory nombre_, string memory apellido_, string memory curso_){
        _nombre = nombre_;
        _apellido = apellido_;
        _curso = curso_;
        _docente = msg.sender;
    }

    function apellido() public view returns (string memory) {
        return  _apellido;
    }

    function appendString(string memory _a, string memory _b, string memory _c) internal virtual view returns (string memory){
        return string(abi.encodePacked(_a, _b, _c));
    }


    function nombre_completo() public view returns (string memory) {
        return appendString (_nombre, " ", _apellido);
    }

    function curso() public view returns (string memory) {
        return _curso;
    }

    function set_nota_materia (uint8 nota_, string memory materia_) public{
        require(_docente == msg.sender, "Solo el docente del alumno puede modificar la nota");
            _notas_materias[materia_] = nota_;
            _materias.push(materia_);    
    }

    function nota_materia(string memory materia_) public view returns (uint8) {
        return _notas_materias[materia_];
    }

    function aprobo(string memory materia_) public view returns (bool){
        if (_notas_materias[materia_] > 60){
            return true;
        }
        else{
            return false;
        }
    }

    function promedio() public view returns (uint256){
        uint256 sumatotal_ = 0;
        uint256 promedio_ = 0;
        for (uint256 i = 0; i < _materias.length; i++){
            sumatotal_ +=  _notas_materias[_materias[i]];
        }
        promedio_ = sumatotal_ / _materias.length;

        return promedio_;
    }
}