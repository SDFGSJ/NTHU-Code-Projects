#ifndef TURRET5_HPP
#define TURRET5_HPP
#include "Turret.hpp"

class Turret5: public Turret {
public:
	static const int Price;
    Turret5(float x, float y);
	void CreateBullet() override;
};
#endif // TURRET5_HPP
