BUNDLETOOL="./bundletool-all-1.15.4.jar"
KEYSTORE="../../../../Keys/QBox.keystore"
SDK="../../../../Unity/2022.3.7f1/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/"

ADB=$(SDK)"platform-tools/adb"
PACKAGE="com.lsiemens.Qbox"

universal.apk: QBox.apks
	unzip QBox.apks

QBox.apks: QBox.aab
	java -jar $(BUNDLETOOL) build-apks \
		--bundle=./QBox.aab --output=./QBox.apks \
		--ks=$(KEYSTORE) \
		--ks-key-alias=upload \
		--mode=universal \

install: universal.apk
	$(ADB) install ./universal.apk

remove:
	$(ADB) uninstall $(PACKAGE)

test-adb:
	$(ADB) devices

clean:
	rm ./QBox.apks ./toc.pb ./universal.apk -f

clean-all:
	rm ./*.aab ./*.apks ./*.pb ./*.apk -f
