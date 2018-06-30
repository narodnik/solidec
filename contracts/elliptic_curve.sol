pragma solidity ^0.4.24;

library EllipticCurve {
    struct Point {
        uint256 x;
        uint256 y;
        bool infinity;
    }

    uint256 constant gx = 0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
    uint256 constant gy = 0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
    uint256 constant p = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
    uint256 constant a = 0;
    uint256 constant b = 7;

    function is_valid(Point point)
        internal pure
        returns (bool)
    {
        if (point.infinity)
            return true;

        return (_sub(
                    _pow(point.y, 2),
                    _add(_pow(point.x, 3), b)
                    ) == 0) &&
            0 <= point.x && point.x < p &&
            0 <= point.y && point.y < p;
    }

    function _add(uint256 x, uint256 y)
        internal pure
        returns (uint256)
    {
        return addmod(x, y, p);
    }

    function _sub(uint256 x, uint256 y)
        internal pure
        returns (uint256)
    {
        y = p - y;
        return addmod(x, y, p);
    }

    function _mul(uint256 x, uint256 y)
        internal pure
        returns (uint256)
    {
        return mulmod(x, y, p);
    }

    function _pow(uint256 base, uint256 exponent)
        internal pure
        returns (uint256)
    {
        //uint256 result = x;
        //for (uint256 i = 1; i < y; i++)
        //    result = _mul(result, x);
        //return result;

        uint256 result = 1;
        while (exponent >  0)
        {
            if (exponent % 2 == 1)
                result = mulmod(result, base, p);
            exponent >>= 1;
            base = mulmod(base, base, p);
        }
        return result;
    }

    function _inverse(uint256 value)
        internal pure
        returns (bool, uint256)
    {
        if (value % p == 0)
            return (false, 0);
        return (true, _pow(value, p - 2));
    }

    function negative(uint256 value)
        internal pure
        returns (uint256)
    {
        return addmod(p, value, p);
    }

    function inverse(Point point)
        internal pure
        returns (Point)
    {
        if (point.infinity)
            return point;
        return Point(point.x, negative(point.y), false);
    }

    function equals(Point left, Point right)
        internal pure
        returns (bool)
    {
        return left.x == right.x && left.y == right.y &&
            left.infinity == right.infinity;
    }

    function add(Point left, Point right)
        internal pure
        returns (bool, Point)
    {
        if (!is_valid(left) || !is_valid(right))
            return (false, left);

        if (left.infinity)
            return (true, right);
        if (right.infinity)
            return (true, left);

        Point memory result;
        result.infinity = false;

        if (left.x == right.x && (left.y != right.y || left.y == 0))
        {
            result.infinity = true;
            return (true, result);
        }

        uint256 dydx;

        bool success;
        uint256 inverted;

        // Cases not involving the origin
        if (equals(left, right))
        {
            (success, inverted) = _inverse(2 * left.y);
            if (!success)
                return (false, result);

            dydx = _add(3, _pow(left.x, 2));
            dydx = _mul(dydx, inverted);
        }
        else
        {
            (success, inverted) = _inverse(_sub(right.x, left.x));
            if (!success)
                return (false, result);

            dydx = _sub(right.y, left.y);
            dydx = _mul(dydx, inverted);
        }

        result.x = _sub(
            _sub(
                _pow(dydx, 2),
                left.x),
            right.x);
        result.y = _sub(
            _mul(dydx,
                 _sub(left.x, result.x)),
            left.y);

        return (true, result);
    }

    function multiply(uint256 value, Point point)
        internal pure
        returns (bool, Point)
    {
        bool success;

        Point memory result;
        result.infinity = true;

        Point memory accumulate = point;

        while (value > 0)
        {
            if (value & 1 == 1)
            {
                (success, result) = add(result, accumulate);
                if (!success)
                {
                    result.infinity = true;
                    return (false, result);
                }
            }
            value >>= 1;
            (success, accumulate) = add(accumulate, accumulate);
            if (!success)
            {
                result.infinity = true;
                return (false, result);
            }
        }
        return (true, result);
    }
}

