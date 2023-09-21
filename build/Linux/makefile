README="./README.md"
LICENSE="../../LICENSE"
USERGUIDE="../../Documentation/PCUserGuide.md"
EXICUTABLE="./QBox.x86_64"
DATA="./QBox_Data"
UNITYPLAYER="./UnityPlayer.so"

TARGET="./QBox"

package:
	mkdir $(TARGET)
	cp $(README) $(TARGET)/README
	cp $(LICENSE) $(TARGET)/LICENSE
	cp $(USERGUIDE) $(TARGET)/UserGuide

	cp $(DATA) $(UNITYPLAYER) $(TARGET)/ -rf
	cp $(EXICUTABLE) $(TARGET)/QBox

	tar -czvf $(TARGET).tar.gz $(TARGET)

clean:
	rm $(TARGET) $(TARGET).tar.gz -rf
