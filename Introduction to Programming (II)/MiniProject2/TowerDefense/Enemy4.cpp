#include <string>

#include "Enemy4.hpp"
#include "FireBallBullet.hpp"
#include "Turret.hpp"
#include "AudioHelper.hpp"
#include "Group.hpp"
#include "PlayScene.hpp"
#include "Point.hpp"

Enemy4::Enemy4(int x, int y) : Enemy("play/enemy-4.png", x, y, 10, 50, 40, 1, 100) {
    // TODO 2 (6/8): You can imitate the 2 files: 'NormalEnemy.hpp', 'NormalEnemy.cpp' to create a new enemy.
}
void Enemy4::CreateBullet() {
	Engine::Point diff = Engine::Point(-1,0);
	float rotation = ALLEGRO_PI / 2;
	getPlayScene()->BulletGroup->AddNewObject(new FireBallBullet(Position , diff, rotation, this));
	AudioHelper::PlayAudio("gun.wav");
}
