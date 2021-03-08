//
//  FullDevicePairingVC+Bluetooth.swift
//  BagCam
//
//  Created by Pankaj Patel on 22/02/21.
//

import CoreBluetooth

// MARK: - Other Method(s)
extension FullDevicePairingVC {
    
    func prepareBluetoothConfiguration() {
        //Service id: 4fafc201-1fb5-459e-8fcc-c5c9c331914b
        //Characteristic id: beb5483e-36e1-4688-b7f5-ea07361b26a8
        self.cbCentralManager = CBCentralManager(delegate: self, queue: .global())
    }
    
    func connectBluetoothDevice(_ peripheral: CBPeripheral) {
        self.cbCentralManager.stopScan()
        self.connectedPeripheral = peripheral
        self.cbCentralManager.connect(peripheral, options: nil)
    }
}

// MARK: - CBCentralManagerDelegate
extension FullDevicePairingVC: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        /// Check wheather device bluetooth is on.
        switch central.state {
        case .poweredOn:
            /// [CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")]
            central.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("Bluetooth State: \(central.state.rawValue)")
            self.showSimpleAlert("Please turn on bluetooth")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name != nil else {
            return
        }
        print("Bluetooth Name:\(peripheral.name!)")
        if !self.arrCBPeripheral.contains(peripheral) {
            self.arrCBPeripheral.append(peripheral)
            DispatchQueue.main.async {
                self.arrDisplayCellType = [
                    .row([BagImageType.normal,
                          GeneralLabelInfoType.availableDevices,
                          GeneralLabelInfoType.selectBagCam]),
                    .devices(self.arrCBPeripheral)
                ]
                self.tableView.reloadData()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print(#function)
        peripheral.discoverServices(nil)
        peripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print(#function)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("\(#function): \(error?.localizedDescription ?? "")")
    }
}

// MARK: - CBPeripheralDelegate
extension FullDevicePairingVC: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print("Service id: \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for char in characteristics {
                print("Characteristic id: \(char.uuid)")
            }
        }
    }
}
