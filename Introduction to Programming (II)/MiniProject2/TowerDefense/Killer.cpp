#include <allegro5/allegro.h>
#include <cmath>
#include <string>

#include "AudioHelper.hpp"
#include "Collider.hpp"
#include "Enemy.hpp"
#include "GameEngine.hpp"
#include "Group.hpp"
#include "IObject.hpp"
#include "IScene.hpp"
#include "Killer.hpp"
#include "PlayScene.hpp"
#include "Point.hpp"
#include "Resources.hpp"
#include <iostream>
// TODO bonus : Try to finish it.
PlayScene* Killer::getPlayScene() {
	return dynamic_cast<PlayScene*>(Engine::GameEngine::GetInstance().GetActiveScene());
}
Killer::Killer(float x, float y) : Sprite("play/killer.png", x, y, 0, 0, 0, 0){
}
void Killer::Update(float deltaTime){
}
