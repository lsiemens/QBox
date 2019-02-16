#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <iostream>

#include "state_machine.h"

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode);

// const parameters
const GLuint SCREEN_SIZE = 800;

StateMachine GPOCStateMachine(SCREEN_SIZE, SCREEN_SIZE);

int main(int argc, char* argv[]) {
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);

    GLFWwindow* window = glfwCreateWindow(SCREEN_SIZE, SCREEN_SIZE, "GPOC", nullptr, nullptr);
    if (window ==  NULL) {
        std::cout << "GLFW::ERROR: Failed to create window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);

    // glfw callbacks
    glfwSetKeyCallback(window, key_callback);

    // Initalize GLAD
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        std::cout << "GLAD::ERROR: Failed to initalize GLAD" << std::endl;
        glfwTerminate();
        return -1;
    }

    // OpenGL configuration
    glViewport(0, 0, SCREEN_SIZE, SCREEN_SIZE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    GPOCStateMachine.Init();
    GLfloat deltaTime = 0.0f;
    GLfloat lastFrame = 0.0f;

    // Main Loop
    while (!glfwWindowShouldClose(window)) {
        // get timming
        GLfloat currentFrame = glfwGetTime();
        deltaTime = currentFrame - lastFrame;
        lastFrame = currentFrame;

        glfwPollEvents();

        GPOCStateMachine.ProcessInput(deltaTime);
        GPOCStateMachine.Update(deltaTime);

        // Render
        glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        GPOCStateMachine.Render();

        glfwSwapBuffers(window);
    }

    // close window
    glfwTerminate();
    return 0;
}

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mode) {
    if (key==GLFW_KEY_ESCAPE && action==GLFW_PRESS)
        glfwSetWindowShouldClose(window, GL_TRUE);

    if (key>=0 && key<1024) {
        // record if key is currently pressed
        if (action==GLFW_PRESS) {
            GPOCStateMachine.Keys[key] = GL_TRUE;
            GPOCStateMachine.KeysRegistered[key] = GL_FALSE;
        } else if (action==GLFW_RELEASE) {
            GPOCStateMachine.Keys[key] = GL_FALSE;
        }
    }
}
