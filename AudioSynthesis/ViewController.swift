//
//  ViewController.swift
//  AudioSynthesis
//
//  Created by Simon Gladman on 14/10/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var toneWidgets = [ToneWidget]()
    var sineWaveRenderer = SineWaveRenderer()

    var soundGenerator = SoundGenerator()
    var currentNotes = [FrequencyVelocityPair]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(sineWaveRenderer)
   
        for i in 0 ... 3
        {
            let toneWidget = ToneWidget(channelNumber: UInt32(i), frame: CGRectZero)
            
            toneWidget.addTarget(self, action: "toneWidgetChangeHandler:", forControlEvents: UIControlEvents.ValueChanged)
            
            toneWidgets.append(toneWidget)
            view.addSubview(toneWidget)
            
            currentNotes.append(toneWidget.getFrequencyVelocityPair())
            
            soundGenerator.playNoteOn(frequencyVelocityPair: toneWidget.getFrequencyVelocityPair(), channelNumber: toneWidget.getChannelNumber())
        }
    }

    func toneWidgetChangeHandler(toneWidget : ToneWidget)
    {
        soundGenerator.playNoteOff(frequencyVelocityPair: currentNotes[Int(toneWidget.getChannelNumber())], channelNumber: toneWidget.getChannelNumber())
        
        updateSineWave()
        
        soundGenerator.playNoteOn(frequencyVelocityPair: toneWidget.getFrequencyVelocityPair(), channelNumber: toneWidget.getChannelNumber())
        
        currentNotes[Int(toneWidget.getChannelNumber())] = toneWidget.getFrequencyVelocityPair()
    }


    func updateSineWave()
    {
        var values = [FrequencyVelocityPair]()
        
        for widget in toneWidgets
        {
            values.append(widget.getFrequencyVelocityPair())
        }
        
        sineWaveRenderer.setFrequencyVelocityPairs(values)
    }
    
    override func viewDidLayoutSubviews()
    {
        let sineWaveRendererWidth = Int(view.frame.width - 40)
        
        sineWaveRenderer.frame = CGRect(x: Int(view.frame.width / 2) - sineWaveRendererWidth / 2, y: Int(topLayoutGuide.length), width: sineWaveRendererWidth, height: 125)
        
        let columWidth = view.frame.width / 4
        let targetY = view.frame.height - 625 + topLayoutGuide.length
        
        for (i: Int, toneWidget: ToneWidget) in enumerate(toneWidgets)
        {
            let targetX = CGFloat(i) * columWidth + (columWidth / 2) - CGFloat(Constants.width / 2)
            
            toneWidget.frame = CGRect(x: targetX, y: targetY, width: CGFloat(Constants.width), height: 625)
        }
        
        updateSineWave()
    }
    
    override func supportedInterfaceOrientations() -> Int
    {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }

}

struct Constants
{
    static let width = 220
}

