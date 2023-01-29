#include <string>

#include "NormalEnemy.hpp"
#include "FireballBullet.hpp"
#include "Turret.hpp"
#include "AudioHelper.hpp"
#include "Group.hpp"
#include "PlayScene.hpp"
#include "Point.hpp"

NormalEnemy::NormalEnemy(int x, int y) : Enemy("play/enemy-1.png", x, y, 10, 50, 20, 1, 5) {
    // TODO 2 (6/8): You can imitate the 2 files: 'NormalEnemy.hpp', 'NormalEnemy.cpp' to create a new enemy.
}
void NormalEnemy::CreateBullet(){
	Engine::Point diff = Engine::Point(-1,0);
	float rotation = ALLEGRO_PI / 2;
	getPlayScene()->BulletGroup->AddNewObject(new FireBallBullet(Position , diff, rotation, this));
	AudioHelper::PlayAudio("gun.wav");
}
