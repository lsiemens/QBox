#ifndef RESOURCE_MANAGER_H
#define RESOURCE_MANAGER_H

#include <map>
#include <string>

#include <glad/glad.h>

#include "texture.h"
#include "shader.h"

// static singleton resource manager class
class ResourceManager {
public:
    // asset storage
    static std::map<std::string, Shader> Shaders;
    static std::map<std::string, Texture2D> Textures;

    // setup shader
    static void LoadShader(const GLchar* vShaderFile, const GLchar* fShaderFile, const GLchar* gShaderFile, std::string name);
    static Shader GetShader(std::string name);

    // setup texture
    static void LoadTexture(const GLchar* file, std::string name);
    static Texture2D GetTexture(std::string name);

    // cleanup assets
    static void Clear();

private:
    ResourceManager() { }
    static Shader loadShaderFromFile(const GLchar* vShaderFile, const GLchar* fShaderFile, const GLchar* gShaderFile=nullptr);
    static std::string loadSourceCode(const GLchar* sourcePath);
    static Texture2D loadTextureFromFile(const GLchar* file);
};

#endif
