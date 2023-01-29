#ifndef CHIPBULLET_HPP
#define CHIPBULLET_HPP
#include "Bullet.hpp"

class Enemy;
class Turret;
namespace Engine {
struct Point;
}  // namespace Engine

class ChipBullet : public Bullet {
public:
	explicit ChipBullet(Engine::Point position, Engine::Point forwardDirection, float rotation, Turret* parent);
	void OnExplode(Enemy* enemy) override;
};
#endif // CHIPBULLET_HPP
