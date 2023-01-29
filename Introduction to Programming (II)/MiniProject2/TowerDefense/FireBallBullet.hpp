#ifndef FIREBALLBULLET_HPP
#define FIREBALLBULLET_HPP
#include "EnemyBullet.hpp"
class Enemy;
class Turret;
namespace Engine {
struct Point;
}  // namespace Engine

class FireBallBullet : public EnemyBullet {
public:
	explicit FireBallBullet(Engine::Point position, Engine::Point forwardDirection, float rotation, Enemy* enemy);
	void OnExplode(Turret* turret);
};
#endif // FIREBALLBULLET_HPP