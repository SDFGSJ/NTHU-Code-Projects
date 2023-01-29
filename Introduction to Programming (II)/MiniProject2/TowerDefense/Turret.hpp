#ifndef TURRET_HPP
#define TURRET_HPP
#include <allegro5/base.h>
#include <list>
#include <string>

#include "Sprite.hpp"
#include "Enemy.hpp"
#include "EnemyBullet.hpp"

class Enemy;
class PlayScene;

class Turret: public Engine::Sprite {
protected:
    int price;
    float coolDown;
    float hp;
    float reload = 0;
    float rotateRadian = 2 * ALLEGRO_PI;
    std::list<Turret*>::iterator lockedTurretIterator;
    PlayScene* getPlayScene();
    // Reference: Design Patterns - Factory Method.
    virtual void OnExplode();
    virtual void CreateBullet() = 0;
public:
    bool Enabled = true;
    bool Preview = false;
    std::list<Enemy*> lockedEnemies;
	std::list<EnemyBullet*> lockedBullets;
    Enemy* Target = nullptr;
    Turret(/*std::string imgBase,*/std::string imgTurret, float x, float y,/* float radius,*/ int price, float coolDown,float hp);
    void Update(float deltaTime) override;
    void Hit(float damage);
    void Draw() const override;
	int GetPrice() const;
};
#endif // TURRET_HPP
