#ifndef TURRETSHOOTEFFECT_HPP
#define TURRETSHOOTEFFECT_HPP
#include <allegro5/bitmap.h>
#include <memory>
#include <vector>

#include "Sprite.hpp"

class PlayScene;

class TurretShootEffect : public Engine::Sprite {
protected:
	PlayScene* getPlayScene();
	float timeTicks;
	std::vector<std::shared_ptr<ALLEGRO_BITMAP>> bmps;
	float timeSpan = 0.5;
public:
	TurretShootEffect(float x, float y);
	void Update(float deltaTime) override;
};
#endif // TURRETSHOOTEFFECT_HPP
