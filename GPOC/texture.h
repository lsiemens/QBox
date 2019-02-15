#ifndef TEXTURE_H
#define TEXTURE_H

#include <glad/glad.h>

// Arbitray shader class
class Texture2D {
public:

    // State variables
    GLuint ID;

    GLuint Width, Height;
    GLuint Internal_Format;
    GLuint Image_Format;
    GLboolean Use_Mipmap;

    //OpenGL texture setting
    GLuint Wrap_S;
    GLuint Wrap_T;
    GLuint Filter_Min;
    GLuint Filter_Max;

    // Constructor
    Texture2D();

    void Generate(GLuint widht, GLuint height, unsigned char* data);
    void Bind() const;
};

#endif
