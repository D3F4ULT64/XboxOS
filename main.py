import os
import sys
import importlib.util


BASE_FOLDER = os.path.dirname(os.path.abspath(__file__))
APPS_FOLDER = os.path.join(BASE_FOLDER, "apps")
GAMES_FOLDER = os.path.join(APPS_FOLDER, "games")


def find_app(name):

    # Check normal apps
    app_file = os.path.join(
        APPS_FOLDER,
        name + ".py"
    )

    if os.path.exists(app_file):
        return app_file


    # Check games
    game_file = os.path.join(
        GAMES_FOLDER,
        name + ".py"
    )

    if os.path.exists(game_file):
        return game_file


    return None



def launch(file):

    spec = importlib.util.spec_from_file_location(
        "xboxos_app",
        file
    )

    module = importlib.util.module_from_spec(spec)

    spec.loader.exec_module(module)


    if hasattr(module, "run"):
        module.run()

    else:
        print("This app has no run() function.")



def main():

    if len(sys.argv) < 2:
        print("Usage: xboxos <app>")
        return


    command = sys.argv[1]


    file = find_app(command)


    if file:
        launch(file)
        return


    print("Unknown command:", command)

    print("Try:")
    print("  xboxos help")



if __name__ == "__main__":
    main()