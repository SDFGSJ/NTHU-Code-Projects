#ifndef RBCELLTURRET_HPP
#define RBCELLTURRET_HPP
#include "Turret.hpp"

class RBCellTurret: public Turret {
public:
	static const int Price;
    RBCellTurret(float x, float y);
	void CreateBullet() override;
	void Update();
};
#endif // RBCELLTURRET_HPP
