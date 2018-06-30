pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "../contracts/elliptic_curve.sol";

contract TestEllipticCurve {

    function test_add() public
    {
        EllipticCurve.Point memory left = EllipticCurve.Point(
            0x45dbb7e2cd3a5de19fde8d556fd567a036f9c377ecf69a9202aa4affce41c623,
            0xfb74cec47fcb01e4164ad0ce1fe122d1e1c333202942592ec7a10bd55e71dbc0,
            false);

        EllipticCurve.Point memory right = EllipticCurve.Point(
            0xcfc43e064c50cfd1896766ef70e7da82b16e8cfebd8d5dec618212d0db1e6d12,
            0x134753afc9719a04f0d5734c57407a527a08cab6dededb3c867e01402f9aa0d4, 
            false);
        bool success;
        EllipticCurve.Point memory result;
        (success, result) = EllipticCurve.add(left, right);

        uint256 x =
            0x332bf6821c7c0e1080efc131d2b745760a8245c0b91a05f13308ff8600d30525;
        uint256 y =
            0xd5b81467f40acac3a13c6432d4bfd448c8568b62a79badb41202f55db03d0569;

        Assert.equal(success, true, "not success");
        Assert.equal(result.x, x, "x not equal");
        Assert.equal(result.y, y, "x not equal");
    }

    function test_multiply() public
    {
        uint256 value =
            0x8010b1bb119ad37d4b65a1022a314897b1b3614b345974332cb1b9582cf03536;

        EllipticCurve.Point memory generator = EllipticCurve.Point(
            0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798,
            0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8,
            false);

        bool success;
        EllipticCurve.Point memory result;
        (success, result) = EllipticCurve.multiply(value, generator);

        uint256 x =
            0x09ba8621aefd3b6ba4ca6d11a4746e8df8d35d9b51b383338f627ba7fc732731;
        uint256 y =
            0x8c3a6ec6acd33c36328b8fb4349b31671bcd3a192316ea4f6236ee1ae4a7d8c9;

        Assert.equal(success, true, "not success");
        Assert.equal(result.x, x, "x not equal");
        Assert.equal(result.y, y, "x not equal");
    }
}

