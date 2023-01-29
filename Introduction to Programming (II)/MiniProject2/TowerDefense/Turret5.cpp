#include <allegro5/base.h>
#include <cmath>
#include <string>

#include "AudioHelper.hpp"
#include "Group.hpp"
#include "Turret5.hpp"
#include "PlayScene.hpp"
#include "Point.hpp"
//#include "ChipBullet.hpp"
#include "Enemy.hpp"

const int Turret5::Price = 90;
Turret5::Turret5(float x, float y) :
    // TODO 2 (2/8): You can imitate the 2 files: 'FreezeTurret.hpp', 'FreezeTurret.cpp' to create a new turret.
	Turret("play/turret-5.png", x, y, Price, 0.5, 100) {
	// Move center downward, since we the turret head is slightly biased upward.
	Anchor.y += 8.0f / GetBitmapHeight();
}
void Turret5::CreateBullet() {
	/*Engine::Point diff = Engine::Point(1,0);
	float rotation = ALLEGRO_PI / 2;
	getPlayScene()->BulletGroup->AddNewObject(new ChipBullet(Position , diff, rotation, this));
	AudioHelper::PlayAudio("gun.wav");*/
}
