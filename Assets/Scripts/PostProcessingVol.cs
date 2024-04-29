using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class PostProcessingVol : MonoBehaviour
{
    [SerializeField] Volume vol;

    private bool _toggle;
    void Update()
    {
        if(Input.GetKeyUp(KeyCode.Space))
        {
            _toggle = !_toggle;
        }

        if (_toggle)
        {
            if (vol.profile.TryGet<Bloom>(out Bloom blum))
            {
                blum.intensity.value = 1f;
            }
        }
        else if (!_toggle) {
            if (vol.profile.TryGet<Bloom>(out Bloom blum))
            {
                blum.intensity.value = 0f;
            }
        }
    }

    public bool Toggle(bool toggle)
    {
        toggle = _toggle;
        return toggle;
    }
}
