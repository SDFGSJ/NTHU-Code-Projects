#include <allegro5/base.h>
#include <cmath>
#include <string>

#include "AudioHelper.hpp"
#include "Group.hpp"
#include "RBCellTurret.hpp"
#include "PlayScene.hpp"
#include "Point.hpp"
#include "ChipBullet.hpp"
#include "Enemy.hpp"
#include "GameEngine.hpp"
#include "Collider.hpp"
#include "Turret.hpp"
const int RBCellTurret::Price = 50;
RBCellTurret::RBCellTurret(float x, float y) :
    // TODO 2 (2/8): You can imitate the 2 files: 'FreezeTurret.hpp', 'FreezeTurret.cpp' to create a new turret.
	Turret("play/turret-3.png", x, y, Price, 0.5, 1) {
	// Move center downward, since we the turret head is slightly biased upward.
	Anchor.y += 8.0f / GetBitmapHeight();
}
void RBCellTurret::CreateBullet() {
	Engine::Point diff = Engine::Point(1,0);
	float rotation = ALLEGRO_PI / 2;
	getPlayScene()->BulletGroup->AddNewObject(new ChipBullet(Position , diff, rotation, this));
	AudioHelper::PlayAudio("gun.wav");
}
