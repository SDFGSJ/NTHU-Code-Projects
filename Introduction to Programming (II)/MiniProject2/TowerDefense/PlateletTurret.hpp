#ifndef PLATELETTURRET_HPP
#define PLATELETTURRET_HPP
#include "Turret.hpp"

class PlateletTurret: public Turret {
public:
	static const int Price;
    PlateletTurret(float x, float y);
	void CreateBullet() override;
	void Update(float deltaTime) override;
};
#endif // PLATELETTURRET_HPP
