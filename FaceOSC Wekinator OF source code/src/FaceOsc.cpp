#include "FaceOsc.h"


void FaceOsc::sendFaceOscWekinator(ofxFaceTracker& tracker) {
    
    if(tracker.getFound()) {
        clearBundle();


        ofVec2f position = tracker.getPosition();
        ofVec3f orientation = tracker.getOrientation();
        
        ofxOscMessage msg;
        msg.setAddress("/wek/inputs");
        msg.addFloatArg(position.x);
        msg.addFloatArg(position.y);
        msg.addFloatArg(tracker.getScale());
        msg.addFloatArg(orientation.x);
        msg.addFloatArg(orientation.y);
        msg.addFloatArg(orientation.z);
        msg.addFloatArg(tracker.getGesture(ofxFaceTracker::MOUTH_WIDTH));
        msg.addFloatArg(tracker.getGesture(ofxFaceTracker::MOUTH_HEIGHT));
        msg.addFloatArg(tracker.getGesture(ofxFaceTracker::LEFT_EYEBROW_HEIGHT));
        msg.addFloatArg(tracker.getGesture(ofxFaceTracker::RIGHT_EYEBROW_HEIGHT));
        msg.addFloatArg(tracker.getGesture(ofxFaceTracker::LEFT_EYE_OPENNESS));
        msg.addFloatArg(tracker.getGesture(ofxFaceTracker::RIGHT_EYE_OPENNESS));
        msg.addFloatArg(tracker.getGesture(ofxFaceTracker::JAW_OPENNESS));
        msg.addFloatArg(tracker.getGesture(ofxFaceTracker::NOSTRIL_FLARE));
        bundle.addMessage(msg);
    
    
        sendBundle();
    
    }
    
}

void FaceOsc::sendFaceOsc(ofxFaceTracker& tracker) {
    clearBundle();
    
    if(tracker.getFound()) {
        addMessage("/found", 1);
        
        if(bIncludePose) {
            ofVec2f position = tracker.getPosition();
            addMessage("/pose/position", position);
            addMessage("/pose/scale", tracker.getScale());
            ofVec3f orientation = tracker.getOrientation();
            addMessage("/pose/orientation", orientation);
        }
        
        if (bIncludeGestures) {
            addMessage("/gesture/mouth/width", tracker.getGesture(ofxFaceTracker::MOUTH_WIDTH));
            addMessage("/gesture/mouth/height", tracker.getGesture(ofxFaceTracker::MOUTH_HEIGHT));
            addMessage("/gesture/eyebrow/left", tracker.getGesture(ofxFaceTracker::LEFT_EYEBROW_HEIGHT));
            addMessage("/gesture/eyebrow/right", tracker.getGesture(ofxFaceTracker::RIGHT_EYEBROW_HEIGHT));
            addMessage("/gesture/eye/left", tracker.getGesture(ofxFaceTracker::LEFT_EYE_OPENNESS));
            addMessage("/gesture/eye/right", tracker.getGesture(ofxFaceTracker::RIGHT_EYE_OPENNESS));
            addMessage("/gesture/jaw", tracker.getGesture(ofxFaceTracker::JAW_OPENNESS));
            addMessage("/gesture/nostrils", tracker.getGesture(ofxFaceTracker::NOSTRIL_FLARE));
        }
        
        if(bIncludeAllVertices){
            ofVec2f center = tracker.getPosition();
            ofxOscMessage msg;
            msg.setAddress("/raw");
            for(ofVec2f p : tracker.getImagePoints()) {
                if (bNormalizeRaw) {
                    msg.addFloatArg((p.x-center.x)/tracker.getScale());
                    msg.addFloatArg((p.y-center.y)/tracker.getScale());
                }
                else {
                    msg.addFloatArg(p.x);
                    msg.addFloatArg(p.y);
                }
            }
            bundle.addMessage(msg);
        }

    } else {
        addMessage("/found", 0);
    }
    
    sendBundle();
}

void FaceOsc::clearBundle() {
	bundle.clear();
}

void FaceOsc::addMessage(string address, ofVec3f data) {
	ofxOscMessage msg;
	msg.setAddress(address);
	msg.addFloatArg(data.x);
	msg.addFloatArg(data.y);
	msg.addFloatArg(data.z);
	bundle.addMessage(msg);
}

void FaceOsc::addMessage(string address, ofVec2f data) {
	ofxOscMessage msg;
	msg.setAddress(address);
	msg.addFloatArg(data.x);
	msg.addFloatArg(data.y);
	bundle.addMessage(msg);
}

void FaceOsc::addMessage(string address, float data) {
	ofxOscMessage msg;
	msg.setAddress(address);
	msg.addFloatArg(data);
	bundle.addMessage(msg);
}

void FaceOsc::addMessage(string address, int data) {
	ofxOscMessage msg;
	msg.setAddress(address);
	msg.addIntArg(data);
	bundle.addMessage(msg);
}

void FaceOsc::sendBundle() {
	osc.sendBundle(bundle);
}
