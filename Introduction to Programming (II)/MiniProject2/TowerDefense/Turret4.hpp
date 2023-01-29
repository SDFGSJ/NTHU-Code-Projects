#ifndef TURRET4_HPP
#define TURRET4_HPP
#include "Turret.hpp"

class Turret4: public Turret {
public:
	static const int Price;
    Turret4(float x, float y);
	void CreateBullet() override;
};
#endif // TURRET4_HPP
