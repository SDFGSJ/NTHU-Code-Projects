#include <allegro5/base.h>
#include <cmath>
#include <string>

#include "AudioHelper.hpp"
//#include "IceCreamBullet.hpp"
#include "Group.hpp"
#include "WBCellTurret.hpp"
#include "PlayScene.hpp"
#include "Point.hpp"
#include "Enemy.hpp"
#include "Bomb.hpp"
const int Bomb::Price = 0;
Bomb::Bomb(float x, float y) :
    // TODO 2 (2/8): You can imitate the 2 files: 'FreezeTurret.hpp', 'FreezeTurret.cpp' to create a new turret.
	Turret("play/bomb.png", x, y, Price, 0.5, 1) {
	// Move center downward, since we the turret head is slightly biased upward.
	//printf("white blood constructed\n");
	Anchor.y += 8.0f / GetBitmapHeight();
}
void Bomb::CreateBullet() {
	//printf("white blood create bullet\n");
	/*Engine::Point diff = Engine::Point(1,0);
	float rotation = ALLEGRO_PI / 2;
	getPlayScene()->BulletGroup->AddNewObject(new IceCreamBullet(Position , diff, rotation, this));
	AudioHelper::PlayAudio("gun.wav");*/
}
