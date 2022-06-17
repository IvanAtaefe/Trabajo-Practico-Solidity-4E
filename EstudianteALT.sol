// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Estudiante{
    string private _nombre;
    string private _apellido;
    string private _curso;
    mapping (address => bool) private _docentes;
    address private _docente;
    string[] private _materias;
    mapping (uint8 => mapping(string => uint8)) private _notas_materias;

    constructor (string memory nombre_, string memory apellido_, string memory curso_){
        _nombre = nombre_;
        _apellido = apellido_;
        _curso = curso_;
        _docente = msg.sender;
        _docentes[msg.sender] = true;
    }

    function apellido() public view returns (string memory) {
        return  _apellido;
    }

    function appendString(string memory _a, string memory _b, string memory _c) internal virtual view returns (string memory){
        return string(abi.encodePacked(_a, _b, _c));
    }

    function stringsEquals(string memory s1, string memory s2) private pure returns (bool) {
    bytes memory b1 = bytes(s1);
    bytes memory b2 = bytes(s2);
    uint256 l1 = b1.length;
    if (l1 != b2.length) return false;
    for (uint256 i=0; i<l1; i++) {
        if (b1[i] != b2[i]) return false;
    }
    return true;
}

    function nombre_completo() public view returns (string memory) {
        return appendString (_nombre, " ", _apellido);
    }

    function curso() public view returns (string memory) {
        return _curso;
    }


    function agregardocente (address docentenuevo) public{
        require (_docente == msg.sender, "Solo el docente a cargo puede agregar a otro docente");
        _docentes[docentenuevo] = true;
    }

    event Nota (address _docente, uint8 _nota, string _materia, uint8 _bimestre);

    function set_nota_materia (uint8 nota_, uint8 bimestre_, string memory materia_) public{
        bool encontrado = false;
        require(bimestre_ <= 4, "Solo existen 4 bimestres");
        require(_docentes[msg.sender] == true, "Solo los docentes del alumno puede modificar la nota");  
            _notas_materias[bimestre_][materia_] = nota_;
                for (uint256 i = 0; i < _materias.length; i++){
                    if (stringsEquals(materia_,_materias[i])){
                        encontrado = true;
                    }
                }
                if (encontrado == false){
                    _materias.push(materia_);  
                }
            emit Nota (msg.sender, nota_, materia_, bimestre_);
    }

    function nota_materia(string memory materia_, uint8 bimestre_) public view returns (uint8) {
        return _notas_materias[bimestre_][materia_];
    }

    function aprobo(string memory materia_, uint8 bimestre_) public view returns (bool){
        if (_notas_materias[bimestre_][materia_] > 60){
            return true;
        }
        else{
            return false;
        }
    }

    function promedio() public view returns (uint256){
        uint256 sumatotal_ = 0;
        uint256 promedio_ = 0;
        for (uint8 ii = 0; ii <= 4; ii++){
            for (uint256 i = 0; i < _materias.length; i++){
                if(_notas_materias[ii][_materias[i]] != 0){
                    sumatotal_ +=  _notas_materias[ii][_materias[i]];
                }
            }
            promedio_ = sumatotal_ / _materias.length;
        }
        return promedio_;
    }
}